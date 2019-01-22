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
            xtype: 'container',
            items: [
                {
                    xtype: 'datepickernativefield',
                    name: 'startDate',
                    label: 'Start Date',
                    bind: '{wardList.selection.start_date}',
                    dateFormat: 'Y-m-d'
                },
                {
                    xtype: 'textfield',
                    name: 'startTime',
                    label: 'Start Time',
                    bind: '{wardList.selection.start_time}',
                }
            ]
        }, {
            xtype: 'container',
            items: [
                {
                    xtype: 'datepickernativefield',
                    name: 'endDate',
                    label: 'End Date',
                    bind: '{wardList.selection.end_date}',
                    dateFormat: 'Y-m-d'
                },
                {
                    xtype: 'textfield',
                    name: 'endTime',
                    label: 'End Time',
                    bind: '{wardList.selection.end_time}',
                }
            ]
        }
    ]
});