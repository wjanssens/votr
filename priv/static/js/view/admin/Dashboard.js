Ext.define('Votr.view.admin.Dashboard', {
    extend: 'Ext.form.Panel',
    alias: 'widget.admin.dashboard',
    layout: 'vbox',
    defaults: {
        margin: 0
    },
    viewModel: {

    },
    items: [
        {
            layout: 'hbox',
            defaults: {
                margin: 10,
                shadow: true,
                flex: 1,
                height: 96,
                padding: 0
            },
            items: [
                {
                    xtype: 'panel',
                    layout: 'hbox',
                    title: 'Elections',
                    iconCls: 'x-fa fa-map-marker',
                    items: [
                        {
                            xtype: 'button',
                            width: '100%',
                            handler: 'onElections',
                            bind: {
                                html: '<span style="text-align: center; line-height: 1em; font-size: 24px;">{ward_ct}</span>'
                            }
                        }
                    ]
                },
                {
                    xtype: 'panel',
                    layout: 'hbox',
                    title: 'Polls',
                    iconCls: 'x-fa fa-check-square',
                    items: [
                        {
                            xtype: 'button',
                            width: '100%',
                            handler: 'onPolls',
                            bind: {
                                html: '<span style="text-align: center; line-height: 1em; font-size: 24px;">{ballot_ct}</span>'
                            }
                        }
                    ]
                },
                {
                    xtype: 'panel',
                    layout: 'hbox',
                    title: 'Counts',
                    iconCls: 'x-fa fa-users',
                    items: [
                        {
                            xtype: 'button',
                            width: '100%',
                            handler: 'onCounts',
                            bind: {
                                html: '<span style="text-align: center; line-height: 1em; font-size: 24px;">{voter_ct}</span>'
                            }
                        }
                    ]
                },
            ]
        },
        {
            xtype: 'panel',
            layout: 'hbox',
            padding: 0,
            defaults: {
                shadow: true,
                flex: 1,
                margin: 10
            },
            items: [
                {
                    xtype: 'panel',
                },
                {
                    xtype: 'panel'
                }
            ]
        }
    ]
});