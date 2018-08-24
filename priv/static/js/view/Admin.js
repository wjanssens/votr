Ext.define('Votr.view.Admin', {
    extend: 'Ext.Panel',
    alias: 'widget.admin',
    padding: 0,
    layout: 'hbox',
    items: [
        {
            xtype: 'toolbar',
            itemId: 'toolbar',
            docked: 'top',
            title: 'Votr',
            items: [
                {
                    xtype: 'button',
                    itemId: 'back',
                    iconCls: 'x-fa fa-chevron-left',
                    tooltip: 'Back'
                }, '->',
                {
                    xtype: 'button',
                    itemId: 'account',
                    iconCls: 'x-fa fa-user-circle',
                    tooltip: 'Account'
                },
                {
                    xtype: 'button',
                    itemId: 'signOut',
                    iconCls: 'x-fa fa-sign-out',
                    tooltip: 'Sign Out'
                }
            ]
        }, {
            xtype: 'users'
        }
    ]
});