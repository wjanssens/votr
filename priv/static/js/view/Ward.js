Ext.define('Votr.view.Ward', {
    extend: 'Ext.Panel',
    alias: 'widget.ward',
    items: [
        {
            xtype: 'panel',
            padding: 0,
            items: [{
                xtype: 'textfield',
                name: 'title',
                label: 'Title *'
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