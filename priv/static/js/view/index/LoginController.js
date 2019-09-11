Ext.define('Votr.view.index.LoginController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.index.login',

    onLanguageChange: function (field, newValue) {
        var lang = newValue.id;
        if (lang === 'default') window.location.href = '..'; // server side conneg will select something
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
        let form = this.getView().down('#voterId');
        let values = form.getValues();

        // TODO
        // send the voter credentials to the server
        // 200: -> #ballots
        window.location.href = '/voter';
        // 401: show error message
    },

    onAdminCredentials: function () {
        let form = this.getView().down('#adminId');
        let values = form.getValues();
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
                if (obj.error === 'mfa_required') {
                    this.redirectTo("#mfa");
                    form.down('#token').setValue(obj.token);
                } else if (obj.error === 'unauthorized') {
                    form.down('#message').setHtml('Invalid credentials'.translate());
                } else if (obj.message) {
                    form.down('#message').setHtml(obj.message);
                } else {
                    form.down('#message').setHtml('Unexpected error'.translate());
                }
            }
        });
    },

    onAdminForgotPassword: function () {
        this.getView().setActiveItem(2);
    },

    onAdminMfa: function () {
        let form = this.getView().down('#adminMfa');
        let values = form.getValues();
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
                if (obj.error === 'unauthorized')  {
                    form.down('#message').setHtml('Invalid code'.translate());
                } else if (obj.message) {
                    form.down('#message').setHtml(obj.message);
                } else {
                    form.down('#message').setHtml('Unexpected error'.translate());
                }
            }
        });
    },

    onAdminRegistration: function () {
        let form = this.getView().down('#register');
        let values = form.getValues();
        Ext.Ajax.request({
            url: '/api/subjects',
            jsonData: Ext.util.JSON.encode({
                username: values.email,
                password: values.password
            }),
            success: () => {
                this.getView().down('#signUpCards').setActiveItem(1);
            },
            failure: () => {
                form.down('#message').setHtml('Unexpected error'.translate());
            }
        })
    },

    onEmailConfirmationKeyUp: function(field, e) {
        if (e.getKey() == e.ENTER) {
            this.onEmailConfirmation();
        }
    },

    onEmailConfirmation: function () {
        let form = this.getView().down('#confirm');
        let values = form.getValues();
        Ext.Ajax.request({
            url: '/api/activate',
            jsonData: Ext.util.JSON.encode({
                code: values.code
            }),
            success: () => {
                window.location.href = '/admin';
            },
            failure: (response) => {
                if (response.status === 404) {
                    form.down('#message').setHtml('Invalid code'.translate());
                } else {
                    form.down('#message').setHtml('Unexpected error'.translate());
                }
            }
        });
    },

    onEnter: function(event) {
        var next = field.up('form').down('#next');
        next.fireEvent('click', next, event, options);
    },

    installCodeFormatter: function (c) {
        try {
            const input = c.el.selectNode('input');
//            new Formatter(input, {
//                'pattern': '{{****}} {{****}} {{****}} {{****}}',
//                'persistent': true
//            });
            input.style = "text-transform: uppercase;"
        } catch (e) {
            console.log(e);
        }
    },

    validateRegistration: function () {
        let form = this.getView().down('#register');
        let values = form.getValues();
        let email = values.email;
        let password = values.password;
        let retype = values.retype_password;

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
        if (password === '') {
            form.down('#password').setUserCls('x-invalid');
            disabled = true;
        }
        if (email === '') {
            form.down('#email').setUserCls('x-invalid');
            disabled = true;
        }

        // form.down('#message').setHtml(message);
        form.down('#next').setDisabled(disabled);

    }
});
