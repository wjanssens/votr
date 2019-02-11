Ext.define('Votr.view.admin.Ward', {
    extend: 'Ext.form.Panel',
    alias: 'widget.admin.ward',
    bind: {
        disabled: '{!wardList.selection}'
    },
    items: [
        {
            xtype: 'panel',
            layout: 'hbox',
            padding: 0,
            items: [{
                xtype: 'textfield',
                name: 'name',
                label: 'Name *',
                flex: 1,
                bind: {
                    value: '{name}',
                    placeHolder: '{wardList.selection.names.default}'
                }
            }, {
                xtype: 'selectfield',
                label: 'Language',
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
                label: 'Description *',
                flex: 1,
                bind: {
                    value: '{description}',
                    placeHolder: '{wardList.selection.descriptions.default}'
                }
            }, {
                xtype: 'selectfield',
                label: 'Language',
                width: 128,
                bind: {
                    store: '{languages}',
                    value: '{language}'
                }
            }]
        }, {
            xtype: 'textfield',
            name: 'ext_id',
            label: 'External ID',
            bind: '{wardList.selection.ext_id}'
        }, {
            xtype: 'textfield',
            name: 'start_at',
            label: 'Start At',
            placeHolder: 'yyyy-mm-dd hh:mm [±hh:mm]',
            bind: '{wardList.selection.start_at}'
        }, {
            xtype: 'textfield',
            name: 'end_at',
            label: 'End At',
            placeHolder: 'yyyy-mm-dd hh:mm [±hh:mm]',
            bind: '{wardList.selection.end_at}'
        }, {
            xtype: 'textfield',
            name: 'updated_at',
            label: 'Update At',
            readOnly: true,
            bind: '{wardList.selection.update_at}'
        }, {
            xtype: 'panel',
            layout: 'hbox',
            items: [
                {flex: 1},
                {
                    xtype: 'button', ui: 'alt round', margin: 8, height: 96, width: 96, handler: 'onWards', bind: {
                        html: '<span style="line-height: 1em; font-size: 24px;">{wardList.selection.ward_ct}</span><br/>Wards'
                    }
                },
                {
                    xtype: 'button', ui: 'alt round', margin: 8, height: 96, width: 96, handler: 'onBallots', bind: {
                        html: '<span style="line-height: 1em; font-size: 24px;">{wardList.selection.ballot_ct}</span><br/>Ballots'
                    }
                },
                {
                    xtype: 'button', ui: 'alt round', margin: 8, height: 96, width: 96, handler: 'onVoters', bind: {
                        html: '<span style="line-height: 1em; font-size: 24px;">{wardList.selection.voter_ct}</span><br/>Voters'
                    }
                },
                {flex: 1}
            ]
        }
    ]
});