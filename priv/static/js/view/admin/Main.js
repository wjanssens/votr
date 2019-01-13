Ext.define('Votr.view.admin.Main', {
    extend: 'Ext.Panel',
    alias: 'widget.admin.main',
    padding: 0,
    layout: 'hbox',
    requires: [
        "Votr.view.admin.MainController"
    ],
    controller: 'admin.main',
    items: [
        {
            xtype: 'toolbar',
            itemId: 'toolbar',
            docked: 'top',
            title: 'Votr',
            items: [
                {
                    xtype: 'button',
                    iconCls: 'x-fa fa-home',
                    tooltip: 'Home',
                    handler: 'onHome'
                }, '->', {
                    xtype: 'button',
                    iconCls: 'x-fa fa-user-circle',
                    tooltip: 'Account',
                    handler: 'onProfileEdit'
                },
                {
                    xtype: 'button',
                    iconCls: 'x-fa fa-sign-out',
                    tooltip: 'Sign Out',
                    handler: 'onSignOut'
                }
            ]
        }, {
            xtype: 'panel',
            itemId: 'cards',
            flex: 1,
            layout: 'card',
            padding: 0,
            items: [
                {xtype: 'admin.wards'},
                {xtype: 'admin.ballots'},
                {xtype: 'admin.voters'},
                {xtype: 'admin.candidates'},
                {xtype: 'admin.results'},
                {xtype: 'admin.profile'}
            ]
        }
    ]
});