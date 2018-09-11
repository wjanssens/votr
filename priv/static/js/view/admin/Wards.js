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
                model: 'Votr.model.Ward',
                rootVisible: false,
                root: {
                    text: 'All',
                    expanded: true,
                    children: [
                        {name: { default: 'Ward 1' }, description: { default: 'Description 1' }, leaf: true},
                        {
                            name: { default: 'Ward 2' }, description: { default: 'Description 2' }, leaf: false, children:
                                [
                                    {name: { default: 'Ward 21' }, description: { default: 'Description 21' }, leaf: true},
                                    {name: { default: 'Ward 22' }, description: { default: 'Description 22' }, leaf: true},
                                ]
                        },
                        {name: { default: 'Ward 3' }, description: { default: 'Description 3' }, leaf: true},
                        {name: { default: 'Ward 4' }, description: { default: 'Description 4' }, leaf: true}
                    ]
                }
            },
            languages: 'Languages'
        },
        formulas: {
            language: {
                bind: {
                    lang: '{lang}'
                },
                get: function(data) {
                    return data.lang;
                },
                set: function(selection) {
                    this.set('lang', selection.id)
                }
            },
            name: {
                bind: {
                    name: '{wardList.selection.name}',
                    lang: '{lang}'
                },
                get: function(data) {
                    return data.name[data.lang];
                },
                set: function(value) {
                    var lang = this.get('lang');
                    var name = this.get('wardList.selection.name');
                    name[lang] = value;
                }
            },
            description: {
                bind: {
                    description: '{wardList.selection.description}',
                    lang: '{lang}'
                },
                get: function(data) {
                    return data.description[data.lang];
                },
                set: function(value) {
                    var lang = this.get('lang');
                    var description = this.get('wardList.selection.description');
                    description[lang] = value;
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
