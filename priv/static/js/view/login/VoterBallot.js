Ext.define('Votr.view.login.VoterBallot', {
    extend: 'Ext.form.Panel',
    alias: 'widget.login.voterballot',
    title: 'Voter Login',
    requires: [
        'Votr.view.login.LoginController'
    ],
    controller: 'login.login',
    tools: [{
        iconCls: 'x-fa fa-language'
    }],
    items: [{
        xtype: 'textfield',
        name: 'ballot_id',
        label: 'Ballot ID'
    },{
        xtype : 'toolbar',
        docked: 'bottom',
        items: [{
            xtype: 'button',
            text: 'Officials',
            handler: 'onAdmin'
        }, '->', {
            xtype: 'button',
            text: 'Next',
            handler: 'onBallotId'
        }]
    }]
});