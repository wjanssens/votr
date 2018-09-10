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
                    placeHolder: '{wardList.selection.name.default}'
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
                    placeHolder: '{wardList.selection.description.default}'
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
            xtype: 'datepickernativefield',
            name: 'startTime',
            label: 'Start Date/Time *',
            bind: '{wardList.selection.start_time}',
            dateFormat: 'Y-m-d'
        }, {
            xtype: 'datepickernativefield',
            name: 'endTime',
            label: 'End Date/Time *',
            bind: '{wardList.selection.end_time}',
            dateFormat: 'Y-m-d'
        }
    ]
});