Ext.define('Votr.view.login.VoterBallot', {
    extend: 'Ext.form.Panel',
    alias: 'widget.login.voterballot',
    requires: [
        'Votr.view.login.LoginController'
    ],
    controller: 'login.login',
    tools: [{
        xtype: 'selectfield',
        label: 'ズA',
        labelAlign: 'left',
        store: 'Languages'
    }],
    title: 'Voter Login'.translate(),
    items: [{
        xtype: 'textfield',
        name: 'ballot_id',
        label: 'Ballot ID'.translate()
    },{
        xtype : 'toolbar',
        docked: 'bottom',
        items: [{
            xtype: 'button',
            text: 'Officials'.translate(),
            handler: 'onAdmin'
        }, '->', {
            xtype: 'button',
            text: 'Next'.translate(),
            handler: 'onBallotId'
        }]
    }]
});