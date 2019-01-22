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
                type: 'tree',
                model: 'Votr.model.admin.Ward',
                rootVisible: false,
                parentIdProperty: 'parent_id',
                proxy: {
                    type: 'ajax',
                    url: '../api/admin/wards',
                    reader: {
                        type: 'json',
                        rootProperty: 'wards'
                    }
                },
                autoLoad: true
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
                    return get('wardList.selection.names')[get('lang')];
                },
                set: function (value) {
                    const names = Object.assign({}, this.get('wardList.selection.names'));
                    names[this.get('lang')] = value;
                    this.get('wardList.selection').set('names', names);
                }
            },
            description: {
                get: function (get) {
                    return get('wardList.selection.descriptions')[get('lang')];
                },
                set: function (value) {
                    const names = Object.assign({}, this.get('wardList.selection.descriptions'));
                    names[this.get('lang')] = value;
                    this.get('wardList.selection').set('names', names);
                }
            }
        }
    },
    items: [{
        xtype: 'tree',
        reference: 'wardList',
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
            text: 'Add Election',
            handler: 'onAddElection'
        }, {
            xtype: 'button',
            text: 'Add Ward',
            handler: 'onAddWard',
            bind: {
                disabled: '{!wardList.selection}'
            }
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
            text: 'Voters',
            ui: 'forward',
            handler: 'onVoters',
            bind: {
                disabled: '{!wardList.selection}'
            }
        }, {
            xtype: 'button',
            text: 'Ballots',
            ui: 'forward',
            handler: 'onBallots',
            bind: {
                disabled: '{!wardList.selection}'
            }
        }, {
            xtype: 'button',
            text: 'Delegates',
            ui: 'forward',
            handler: 'onDelegates',
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
