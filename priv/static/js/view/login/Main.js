Ext.define('Votr.view.login.Main', {
    extend: 'Ext.Panel',
    alias: 'widget.login',
    layout: 'hbox',
    requires: [
        "Votr.view.login.MainController"
    ],
    controller: 'login.main',
    items: [{
        xtype: 'panel',
        flex: 1,
    }, {
        xtype: 'panel',
        width: 512,
        layout: 'vbox',
        items: [
            {
                xtype: 'panel',
                height: 64,
            },
            {
                xtype: 'panel',
                itemId: 'login_cards',
                border: 1,
                height: 384,
                layout: 'card',
                items: [
                    { xtype: 'login.voterballot' },
                    { xtype: 'login.votercredentials' },
                    { xtype: 'login.adminlogin' },
                    { xtype: 'login.adminmfa' },
                    { xtype: 'login.adminregister' },
                    { xtype: 'login.adminforgotpassword' },
                    { xtype: 'login.adminresetpassword' }
                ]
            }
        ]
    }, {
        xtype: 'panel',
        flex: 1,
    }]
});