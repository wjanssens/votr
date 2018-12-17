Ext.define('Votr.view.login.LoginController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.login.login',

    onLanguageChange: function (field, newValue) {
        var lang = newValue.id;
        if (lang == 'default') window.location.href = '..'; // server side conneg will select something
        else window.location.href = '../' + lang;
    },

    onBallotId: function () {
        // send the voter id to the server
        // 200: prompt for voter credentials
        this.redirectTo("#voter");
        // 404: show error message
    },

    onVoterCredentials: function () {
        // send the voter credentials to the server
        // 200: -> #ballots
        window.location.href = '/voter';
        // 401: show error message
    },

    onAdmin: function () {
        this.redirectTo("#admin");
    },

    onAdminCredentials: function () {
        // send the administrator credentials to the server
        // 200: redirect to #wards
        // this.redirectTo("#wards")
        // 401: prompt for mfa
        this.redirectTo("#mfa");
        // 401: show error message
    },

    onAdminForgotPassword: function () {
        this.redirectTo("#forgot");
    },

    onAdminMfa: function () {
        // send mfa to server
        // 200: redirect to wards
        window.location.href = '/admin';
        // 401: show error message
    },

    onAdminRegister: function () {
        this.redirectTo("#register")
    },

    onAdminRegistration: function () {
        let values = this.getView().getValues();
        Ext.Ajax.request({
            url: '/api/subjects',
            jsonData: Ext.util.JSON.encode({
                username: values.email,
                password: values.password
            }),
            success: () => {
                this.redirectTo('#confirm')
            },
            failure: (response) => {
                this.getView().down('#message').setHtml(response.message);
            }
        })
    },

    onSendResetToken: function () {
        let values = this.getView().getValues();
        Ext.Ajax.request({
            url: '/api/subjects',
            jsonData: Ext.util.JSON.encode({
                username: values.email,
                password: values.password
            }),
            success: () => {
                this.redirectTo('#confirm')
            },
            failure: (response) => {
                this.getView().down('#message').setHtml(response.message);
            }
        })
    },

    onEmailConfirmation: function () {
        let values = this.getView().getValues();
        Ext.Ajax.request({
            url: '/api/activate/' + values.code,
            success: () => {
                window.location.href = '/admin';
            },
            failure: (response) => {
                this.getView().down('#message').setHtml(response.message);
            }
        });
    },

    validateRegistration: function () {
        let form = this.getView();
        let email = form.getValues().email;
        let password = form.getValues().password;
        let retype = form.getValues().retype_password;

        form.down('#password').setUserCls('');
        form.down('#retype_password').setUserCls('');

        let message;
        let result = zxcvbn(password || '');

        let stars = '';
        for (let i = 0; i < result.score; i++) {
            stars += '★';
        }
        for (let i = 4; i > result.score; i--) {
            stars += '☆';
        }

        form.down('#password').setLabel('Password'.translate() + ' (' + stars + ')');

        let disabled = false;
        form.down('#password').setUserCls('');
        if (password !== retype) {
            form.down('#retype_password').setUserCls('x-invalid');
            disabled = true;
        }
        if (result.score <= 2) {
            form.down('#password').setUserCls('x-invalid');
            disabled = true;
        }
        if (password == '') {
            form.down('#password').setUserCls('x-invalid');
            disabled = true;
        }
        if (email == '') {
            form.down('#email').setUserCls('x-invalid');
            disabled = true;
        }

        // form.down('#message').setHtml(message);
        form.down('#next').setDisabled(disabled);

    }
});