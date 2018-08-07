Ext.define('Votr.view.Main', {
    extend: 'Ext.Panel',
    padding: 0,
    layout: 'hbox',
    items: [
        {
            xtype: 'toolbar',
            itemId: 'toolbar',
            docked: 'top',
            title: 'Votr',
            items: [
                '->',
                {
                    xtype: 'button',
                    itemId: 'language',
                    iconCls: 'x-fa fa-language',
                    tooltip: 'Language'
                },
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
            xtype: 'panel',
            flex: 1,
            layout: 'hbox',
            padding: 0,
            items: [{
                xtype: 'wards',
                padding: 0,
                width: 256
            }, {
                xtype: 'tabpanel',
                padding: 0,
                flex: 1,
                items: [
                    {title: 'Summary', xtype: 'ward'},
                    {title: 'Ballots', xtype: 'ballots'},
                    {title: 'Voters', xtype: 'voters'}
                ]
            }]
        }
    ]
});