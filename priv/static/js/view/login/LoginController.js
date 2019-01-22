Ext.define('Votr.view.login.LoginController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.login.login',

    onLanguageChange: function (field, newValue) {
        var lang = newValue.id;
        if (lang == 'default') window.location.href = '..'; // server side conneg will select something
        else window.location.href = '../' + lang;
    },

    onBallotId: function () {
        // TODO
        // send the voter id to the server
        // 200: prompt for voter credentials
        this.redirectTo("#voter");
        // 404: show error message
    },

    onVoterCredentials: function () {
        // TODO
        // send the voter credentials to the server
        // 200: -> #ballots
        window.location.href = '/voter';
        // 401: show error message
    },

    onAdmin: function () {
        this.redirectTo("#admin");
    },

    onAdminCredentials: function () {
        let values = this.getView().getValues();
        Ext.Ajax.request({
            url: '/api/login',
            jsonData: Ext.util.JSON.encode({
                client_id: "votr_admin",
                grant_type: "password",
                username: values.email,
                password: values.password
            }),
            success: () => {
                window.location.href = '/admin';
            },
            failure: (response) => {
                const obj = Ext.decode(response.responseText);
                if (obj.error == 'mfa_required') {
                    this.redirectTo("#mfa");
                    this.getView().down('#token').setValue(obj.token);
                } else if (obj.error == 'unauthorized') {
                    this.getView().down('#message').setHtml('Invalid credentials'.translate());
                } else if (obj.message) {
                    this.getView().down('#message').setHtml(obj.message);
                } else {
                    this.getView().down('#message').setHtml('Unexpected error'.translate());
                }
            }
        });
    },

    onAdminForgotPassword: function () {
        this.redirectTo("#forgot");
    },

    onAdminMfa: function () {
        let values = this.getView().getValues();
        Ext.Ajax.request({
            url: '/api/login',
            jsonData: Ext.util.JSON.encode({
                client_id: "votr_admin",
                grant_type: "otp",
                username: values.token_code,
                password: values.totp_code
            }),
            success: () => {
                window.location.href = '/admin';
            },
            failure: (response) => {
                const obj = Ext.decode(response.responseText);
                if (obj.error == 'unauthorized')  {
                    this.getView().down('#message').setHtml('Invalid code'.translate());
                } else if (obj.message) {
                    this.getView().down('#message').setHtml(obj.message);
                } else {
                    this.getView().down('#message').setHtml('Unexpected error'.translate());
                }
            }
        });
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
            failure: () => {
                this.getView().down('#message').setHtml('Unexpected error'.translate());
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
                this.getView().down('#message').setHtml('Unexpected error'.translate());
            }
        })
    },

    onEmailConfirmation: function () {
        let values = this.getView().getValues();
        Ext.Ajax.request({
            url: '/api/activate',
            jsonData: Ext.util.JSON.encode({
                code: values.code
            }),
            success: () => {
                this.redirectTo("#admin");
            },
            failure: (response) => {
                if (response.status == 404) {
                    this.getView().down('#message').setHtml('Invalid code'.translate());
                } else {
                    this.getView().down('#message').setHtml('Unexpected error'.translate());
                }
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