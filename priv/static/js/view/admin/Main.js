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
                },
                {
                    xtype: 'button',
                    iconCls: 'x-fa fa-chevron-left',
                    tooltip: 'Back',
                    handler: function () {
                        Ext.util.History.back();
                    }
                }, '->', {
                    xtype: 'button',
                    iconCls: 'x-fa fa-language',
                    tooltip: 'Language'
                },
                {
                    xtype: 'button',
                    iconCls: 'x-fa fa-user-circle',
                    tooltip: 'Account'
                },
                {
                    xtype: 'button',
                    iconCls: 'x-fa fa-sign-out',
                    tooltip: 'Sign Out'
                }
            ]
        }, {
            xtype: 'panel',
            itemId: 'elector_cards',
            flex: 1,
            layout: 'card',
            padding: 0,
            items: [
                {xtype: 'admin.wards'},
                {xtype: 'admin.ballots'},
                {xtype: 'admin.voters'},
                {xtype: 'admin.candidates'}
            ]
        }
    ]
});