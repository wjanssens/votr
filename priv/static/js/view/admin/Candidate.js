Ext.define('Votr.view.admin.Candidate', {
    extend: 'Ext.Panel',
    alias: 'widget.admin.candidate',
    layout: 'vbox',
    items: [
        {
            xtype: 'formpanel',
            items: [{
                xtype: 'panel',
                layout: 'hbox',
                padding: 0,
                items: [{
                    xtype: 'textfield',
                    name: 'name',
                    label: 'Name *',
                    flex: 1,
                    bind: '{candidateList.selection.name}'
                }, {
                    xtype: 'selectfield',
                    label: 'Language',
                    width: 128,
                    store: 'Languages'
                }]
            }, {
                xtype: 'panel',
                layout: 'hbox',
                padding: 0,
                items: [{
                    xtype: 'textfield',
                    name: 'desc',
                    label: 'Description *',
                    flex: 1,
                    bind: '{candidateList.selection.description}'
                }, {
                    xtype: 'selectfield',
                    label: 'Language',
                    width: 128,
                    store: 'Languages'
                }]
            }, {
                xtype: 'textfield',
                name: 'ext_id',
                label: 'External ID'
            }, {
                xtype: 'checkboxfield',
                name: 'withdrawn',
                label: 'Withdrawn'
            }]
        }
    ]
});