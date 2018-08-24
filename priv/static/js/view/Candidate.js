Ext.define('Votr.view.Candidate', {
    extend: 'Ext.Panel',
    alias: 'widget.candidate',
    layout: 'vbox',
    items: [
        {
            xtype: 'formpanel',
            items: [{
                xtype: 'textfield',
                name: 'name',
                label: 'Name *'
            }, {
                xtype: 'textfield',
                name: 'desc',
                label: 'Description'
            }, {
                xtype: 'textfield',
                name: 'ext_id',
                label: 'External ID'
            }, {
                xtype: 'checkboxfield',
                name: 'withdrawn',
                label: 'Withdrawn'
            }, {
                xtype: 'fieldset',
                title: 'Results',
                items: [
                    {
                        xtype: 'textfield',
                        name: 'votes',
                        label: 'Votes'
                    }, {
                        xtype: 'textfield',
                        name: 'percentage',
                        label: 'Percentage'
                    }, {
                        xtype: 'textfield',
                        name: 'status',
                        label: 'Status'
                    }, {
                        xtype: 'textfield',
                        name: 'round',
                        label: 'Round'
                    }
                ]
            }]
        }
    ]
});