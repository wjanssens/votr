Ext.define('Votr.view.login.LoginController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.login.login',

    onVoterCredentials: function () {
        // TODO
        // send the voter credentials to the server
        // 200: -> #ballots
        window.location.href = '/voter';
        // 401: show error message


/*
        let values = this.getView().getValues();
        Ext.Ajax.request({
            url: '/api/login',
            jsonData: Ext.util.JSON.encode({
                username: values.access_code,
                password: values.identification_number
            }),
            success: () => {
                window.location.href = '/voter';
            },
            failure: (response) => {
                const obj = Ext.decode(response.responseText);
                if (obj.error == 'unauthorized') {
                    this.getView().down('#message').setHtml('Invalid credentials'.translate());
                } else if (obj.message) {
                    this.getView().down('#message').setHtml(obj.message);
                } else {
                    this.getView().down('#message').setHtml('Unexpected error'.translate());
                }
            }
        });

 */
    },

    onSignUp: function () {
        window.location.href = '../login#signup'
        this.redirectTo("#admin");
    },

    onSignIn: function () {
        window.location.href = '../login#signin'
        this.redirectTo("#admin");
    }
});