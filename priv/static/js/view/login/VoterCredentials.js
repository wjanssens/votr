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
        name: 'challenge',
        label: 'challenge'
    }, {
        xtype: 'textfield',
        name: 'response',
        label: 'response'
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