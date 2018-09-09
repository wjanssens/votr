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
                    bind: {
                        value: '{name}',
                        placeHolder: '{candidateList.selection.name.default}'
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
                    name: 'desc',
                    label: 'Description *',
                    flex: 1,
                    bind: {
                        value: '{description}',
                        placeHolder: '{candidateList.selection.description.default}'
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
                label: 'External ID'
            }, {
                xtype: 'checkboxfield',
                name: 'withdrawn',
                label: 'Withdrawn'
            }]
        }
    ]
});