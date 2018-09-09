Ext.define('Votr.view.admin.Ward', {
    extend: 'Ext.Panel',
    alias: 'widget.admin.ward',
    items: [
        {
            xtype: 'panel',
            padding: 0,
            items: [{
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
                },
                {
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
                },
                    {
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
                name: 'startTime',
                label: 'Start Date/Time *',
                bind: '{wardList.selection.start_time}'
            }, {
                xtype: 'textfield',
                name: 'endTime',
                label: 'End Date/Time *',
                bind: '{wardList.selection.end_time}'
            }]
        }
    ]
});