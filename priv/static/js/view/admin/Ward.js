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
                    flex: 1
                },
                {
                    xtype: 'selectfield',
                    label: 'Language',
                    width: 128,
                    store: 'Languages'
                }]
            }, {
                xtype: 'textfield',
                name: 'startTime',
                label: 'Start Date/Time *'
            }, {
                xtype: 'textfield',
                name: 'endTime',
                label: 'End Date/Time *'
            }]
        }
    ]
});