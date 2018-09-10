Ext.define('Votr.view.login.VoterCredentials', {
    extend: 'Ext.form.Panel',
    alias: 'widget.login.votercredentials',
    title: 'Voter Login',
    requires: [
        'Votr.view.login.LoginController'
    ],
    controller: 'login.login',
    items: [{
        xtype: 'textfield',
        name: 'identity_card',
        label: 'Identity Card'
    }, {
        xtype: 'textfield',
        name: 'access_code',
        label: 'Access Code'
    }, {
        xtype: 'toolbar',
        docked: 'bottom',
        items: ['->', {
            xtype: 'button',
            text: 'Next',
            handler: 'onVoterCredentials'
        }]
    }]
});