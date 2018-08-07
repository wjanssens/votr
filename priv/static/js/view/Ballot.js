Ext.define('Votr.view.Ballot', {
    extend: 'Ext.Panel',
    alias: 'widget.ballot',
    layout: 'vbox',
    padding: 0,
    tools: [
        {
            iconCls: 'x-fa fa-trash',
            handler: function () {
            }
        },
        {
            iconCls: 'x-fa fa-chevron-up',
            handler: function () {
            }
        },
        {
            iconCls: 'x-fa fa-chevron-down',
            handler: function () {
            }
        }
    ],
    items: [
        {
            xtype: 'formpanel',
            items: [{
                xtype: 'textfield',
                name: 'title',
                label: 'Title *'
            }, {
                xtype: 'textfield',
                name: 'desc',
                label: 'Description'
            }, {
                xtype: 'textfield',
                name: 'ext_id',
                label: "External ID"
            }, {
                xtype: 'selectfield',
                label: 'Method *',
                queryMode: 'local',
                name: 'method',
                options: [
                    {value: 'STVD', text: 'Single Transferable Vote (Droop Quota)'},
                    {value: 'STVH', text: 'Single Transferable Vote (Hare Quota)'},
                    {value: 'IRV', text: 'Instant Runoff Vote'},
                    {value: 'FPTP', text: 'Plurality Vote (FPTP)'}
                ]
            }, {
                xtype: 'spinnerfield',
                label: 'Electing',
                minValue: 1,
                value: 1,
                stepValue: 1,
                name: 'elect'
            }, {
                xtype: 'checkboxfield',
                name: 'shuffle',
                label: 'Shuffle',
                value: 'shuffle',
                checked: false
            }, {
                xtype: 'checkboxfield',
                name: 'mutable',
                label: 'Mutable',
                value: 'mutable',
                checked: false
            }]
        },
        {
            xtype: 'panel',
            title: 'Candidates',
            padding: 0,
            tools: [
                {
                    iconCls: 'x-fa fa-plus',
                    handler: function () {
                    }
                }
            ],
            items: [
                {
                    xtype: 'grid',
                    columns: [
                        {text: 'Colour', dataIndex: 'color', flex: 1},
                        {text: 'Name', dataIndex: 'name', flex: 2},
                        {text: 'Description', dataIndex: 'desc', flex: 2},
                        {text: 'Withdrawn', dataIndex: 'withdrawn', flex: 1},
                        {text: 'External ID', dataIndex: 'ext_id', flex: 2}
                    ]

                }
            ]
        }
    ]
})
;