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
                    name: 'title',
                    label: 'Title *',
                    flex: 1,
                    bind: '{wardList.selection.text}'
                },
                {
                    xtype: 'selectfield',
                    label: 'Language',
                    width: 128,
                    store: 'Languages'
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