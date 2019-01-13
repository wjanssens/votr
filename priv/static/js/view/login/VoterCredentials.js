Ext.define('Votr.view.login.VoterCredentials', {
    extend: 'Ext.form.Panel',
    alias: 'widget.login.votercredentials',
    requires: [
        'Votr.view.login.LoginController'
    ],
    controller: 'login.login',
    title: 'Voter Login'.translate(),
    tools: [{
        xtype: 'selectfield',
        label: 'ズA',
        labelAlign: 'left',
        store: 'Languages',
        value: /[^:/]*:\/\/[^/]*\/(\w*)/.exec(window.location.href)[1],
        listeners: {
            change: 'onLanguageChange'
        }
    }],
    items: [{
        xtype: 'textfield',
        name: 'access_code',
        label: 'Access Code'.translate()
    }, {
        xtype: 'textfield',
        name: 'identification_number',
        label: 'Identification Number'.translate()
    }, {
        flex: 1
    }, {
        itemId: 'message',
        html: 'Depending on the election this could be a Citizen Card, Passport Card, Voter Card, ' +
        'PAN card, Drivers License, Passport, Tax Number, Employee Number, etc...'.translate()
    }, {
        xtype: 'toolbar',
        docked: 'bottom',
        items: [{
            xtype: 'button',
            text: 'Officials'.translate(),
            handler: 'onAdmin'
        }, '->', {
            xtype: 'button',
            text: 'Next'.translate(),
            handler: 'onVoterCredentials'
        }]
    }
]
})
;