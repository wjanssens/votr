Ext.define('Votr.view.admin.Candidate', {
    extend: 'Ext.form.Panel',
    alias: 'widget.admin.candidate',
    layout: 'vbox',
    bind: {
        disabled: '{!candidateList.selection}'
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
                    placeHolder: '{candidateList.selection.names.default}'
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
                    placeHolder: '{candidateList.selection.descriptions.default}'
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
            xtype: 'selectfield',
            name: 'color',
            label: 'Color',
            bind: {
                store: '{colors}',
                value: '{color}'
            }
        }, {
            xtype: 'filefield',
            label: "Avatar (48x48)",
            name: 'avatar',
            accept: 'image'
        }, {
            xtype: 'checkboxfield',
            name: 'withdrawn',
            label: 'Withdrawn'
        }
    ]
});