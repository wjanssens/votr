Ext.define('Votr.view.admin.Wards', {
    extend: 'Ext.Panel',
    alias: 'widget.admin.wards',
    requires: [
        'Votr.view.admin.WardsController',
        'Ext.grid.plugin.MultiSelection'
    ],
    controller: 'admin.wards',
    padding: 0,
    layout: 'hbox',
    referenceHolder: true,
    viewModel: {
        data: {
            lang: 'default'
        },
        stores: {
            wards: {
                model: 'Votr.model.admin.Ward',
                proxy: {
                    type: 'rest',
                    url: '../api/admin/wards/{id}/wards',
                    reader: { type: 'json', rootProperty: 'wards' }
                }
            },
            languages: 'Languages'
        },
        formulas: {
            language: {
                get: function (get) {
                    return get('lang');
                },
                set: function (selection) {
                    this.set({'lang': selection.id})
                }
            },
            name: {
                get: function (get) {
                    const names = get('wardList.selection.names');
                    return names == null ? '' : names[get('language')];
                },
                set: function (value) {
                    const names = Object.assign({}, this.get('wardList.selection.names'));
                    names[this.get('language')] = value;
                    this.set('wardList.selection.names', names);
                }
            },
            description: {
                get: function (get) {
                    const descriptions = get('wardList.selection.descriptions');
                    return descriptions == null ? '' : descriptions[get('language')];
                },
                set: function (value) {
                    const descriptions = Object.assign({}, this.get('wardList.selection.descriptions'));
                    descriptions[this.get('language')] = value;
                    this.set('wardList.selection.descriptions', descriptions);
                }
            }
        }
    },
    items: [{
        xtype: 'list',
        reference: 'wardList',
        itemTpl: '<div><p>{names.default}<span style="float:right">something</span></p><p style="color: var(--highlight-color)">{descriptions.default}</p></div>',
        width: 384,
        bind: {
            store: '{wards}'
        }
    }, {
        xtype: 'admin.ward',
        flex: 1
    }, {
        xtype: 'toolbar',
        itemId: 'toolbar',
        docked: 'bottom',
        items: [{
            xtype: 'button',
            text: 'Add',
            handler: 'onAdd'
        }, '->', {
            xtype: 'button',
            text: 'Delete',
            ui: 'decline',
            handler: 'onDelete',
            bind: {
                disabled: '{!wardList.selection}'
            }
        }, '->', {
            xtype: 'button',
            text: 'Save',
            ui: 'confirm',
            handler: 'onSave',
            bind: {
                disabled: '{!wardList.selection}'
            }
        }]
    }]
});
