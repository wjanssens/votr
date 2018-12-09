Ext.define('Votr.view.login.LoginController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.login.login',

    onLanguageChange: function(field, newValue) {
        var lang = newValue.id;
        if (lang == 'default') window.location.href = '..'; // server side conneg will select something
        else window.location.href = '../' + lang;
    },

    onBallotId: function() {
        // send the voter id to the server
        // 200: prompt for voter credentials
        this.redirectTo("#voter");
        // 404: show error message
    },

    onVoterCredentials: function() {
        // send the voter credentials to the server
        // 200: -> #ballots
        window.location.href = '/voter';
        // 401: show error message
    },

    onAdmin: function() {
        this.redirectTo("#admin");
    },

    onAdminCredentials: function() {
        // send the administrator credentials to the server
        // 200: redirect to #wards
        // this.redirectTo("#wards")
        // 401: prompt for mfa
        this.redirectTo("#mfa");
        // 401: show error message
    },

    onAdminForgotPassword: function() {
        this.redirectTo("#forgot");
    },

    onAdminMfa: function() {
        // send mfa to server
        // 200: redirect to wards
        window.location.href = '/admin';
        // 401: show error message
    },

    onAdminRegister: function() {
        this.redirectTo("#register")
    },

    onAdminRegistration: function() {
        var values = this.getView().getValues();
        this.redirectTo('#confirmation')
        // Ext.Ajax.request({
        //     url: '/api/subjects',
        //     jsonData: Ext.util.JSON.encode({
        //         username: values.email,
        //         password: values.password
        //     }),
        //     success: () => {
        //         this.redirectTo('#confirmation')
        //     },
        //     failure: () => {
        //
        //     }
        // })
        // send the new registration to the server
        // 200: prompt for email confirmation code
        this.redirectTo('#confirm')
        // 400: show error message
    },

    onSendResetToken: function() {
        // send new password to server
        // 200: prompt for email confirmation code
        this.redirectTo('#confirm')
        // 401: show error message
    },

    onEmailConfirmation: function() {
        // 200: redirect to wards
        window.location.href = '/admin';
    },

    validateRegistration: function() {
        let form = this.getView();
        let email = form.getValues().email;
        let password = form.getValues().password;
        let retype = form.getValues().retype_password;

        let messages = [
            'very weak password'.translate(),
            'weak password'.translate(),
            'moderate password'.translate(),
            'strong password'.translate(),
            'very strong password'.translate()
        ];

        form.down('#password').setUserCls('');
        form.down('#retype_password').setUserCls('');

        let message;
        let result = zxcvbn(password || '');
        let disabled = false;
        message = messages[result.score];
        if (email == '') {
            form.down('#email').setUserCls('x-invalid');
            disabled = true;
        } else if (result.score <= 2) {
            form.down('#password').setUserCls('x-invalid');
            disabled = true;
        } else if (password !== retype) {
            form.down('#retype_password').setUserCls('x-invalid');
            message = 'passwords do not match'.translate();
            disabled = true;
        }

        form.down('#message').setHtml(message);
        form.down('#next').setDisabled(disabled);

    }
});