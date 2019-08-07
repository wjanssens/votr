Ext.define('Votr.view.admin.Ward', {
    extend: 'Ext.form.Panel',
    alias: 'widget.admin.ward',
    bind: {
        disabled: '{!wardList.selection}'
    },
    layout: 'vbox',
    defaults: {
        margin: 0
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
                    title: 'Wards',
                    iconCls: 'x-fa fa-map-marker',
                    items: [
                        {
                            xtype: 'button',
                            width: '100%',
                            handler: 'onWards',
                            bind: {
                                html: '<span style="text-align: center; line-height: 1em; font-size: 24px;">{wardList.selection.ward_ct}</span>'
                            }
                        }
                    ]
                },
                {
                    xtype: 'panel',
                    layout: 'hbox',
                    title: 'Ballots',
                    iconCls: 'x-fa fa-check-square',
                    items: [
                        {
                            xtype: 'button',
                            width: '100%',
                            handler: 'onBallots',
                            bind: {
                                html: '<span style="text-align: center; line-height: 1em; font-size: 24px;">{wardList.selection.ballot_ct}</span>'
                            }
                        }
                    ]
                },
                {
                    xtype: 'panel',
                    layout: 'hbox',
                    title: 'Voters',
                    iconCls: 'x-fa fa-users',
                    items: [
                        {
                            xtype: 'button',
                            width: '100%',
                            handler: 'onVoters',
                            bind: {
                                html: '<span style="text-align: center; line-height: 1em; font-size: 24px;">{wardList.selection.voter_ct}</span>'
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
                    title: 'Properties',
                    layout: 'vbox',
                    items: [
                        {
                            xtype: 'panel',
                            layout: 'hbox',
                            padding: 0,
                            items: [{
                                xtype: 'textfield',
                                name: 'name',
                                label: 'Name'.translate(),
                                flex: 1,
                                bind: {
                                    value: '{name}',
                                    placeHolder: '{wardList.selection.names.default}'
                                }
                            }, {
                                xtype: 'selectfield',
                                label: 'Language'.translate(),
                                width: 128,
                                bind: {
                                    store: '{languages}',
                                    value: '{language}'
                                }
                            }]
                        }, {
                            xtype: 'panel',
                            layout: 'hbox',
                            padding: 0,
                            items: [{
                                xtype: 'textfield',
                                name: 'description',
                                label: 'Description'.translate(),
                                flex: 1,
                                bind: {
                                    value: '{description}',
                                    placeHolder: '{wardList.selection.descriptions.default}'
                                }
                            }, {
                                xtype: 'selectfield',
                                label: 'Language'.translate(),
                                width: 128,
                                bind: {
                                    store: '{languages}',
                                    value: '{language}'
                                }
                            }]
                        }, {
                            xtype: 'textfield',
                            name: 'ext_id',
                            label: 'External ID'.translate(),
                            bind: '{wardList.selection.ext_id}'
                        }, {
                            xtype: 'textfield',
                            name: 'start_at',
                            label: 'Start At'.translate(),
                            placeHolder: 'yyyy-mm-dd hh:mm [±hh:mm]',
                            bind: '{wardList.selection.start_at}'
                        }, {
                            xtype: 'textfield',
                            name: 'end_at',
                            label: 'End At'.translate(),
                            placeHolder: 'yyyy-mm-dd hh:mm [±hh:mm]',
                            bind: '{wardList.selection.end_at}'
                        }, {
                            xtype: 'textfield',
                            name: 'updated_at',
                            label: 'Updated At'.translate(),
                            readOnly: true,
                            bind: '{wardList.selection.updated_at}'
                        }
                    ]
                },
                {
                    xtype: 'panel'
                }
            ]
        }
    ]
});