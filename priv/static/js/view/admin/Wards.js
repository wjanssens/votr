Ext.define('Votr.view.admin.Wards', {
    extend: 'Ext.Panel',
    alias: 'widget.admin.wards',
    requires: [
        'Votr.view.admin.WardsController'
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
        xtype: 'treelist',
        reference: 'wardList',
        width: 384,
        bind: '{wards}',
        itemTpl: '<div class="item"><p>{name.default}</p><p style="color: var(--highlight-color)">{description.default}</p></div>',
    }, {
        xtype: 'admin.ward',
        flex: 1
    }, {
        xtype: 'toolbar',
        itemId: 'toolbar',
        docked: 'bottom',
        items: [{
            xtype: 'button',
            itemId: 'addElection',
            text: 'Add Election',
            handler: 'onAddElection'
        }, {
            xtype: 'button',
            itemId: 'addWard',
            text: 'Add Ward',
            handler: 'onAddWard'
        }, '->', {
            xtype: 'button',
            itemId: 'voters',
            text: 'Voters',
            handler: 'onVoters'
        }, {
            xtype: 'button',
            itemId: 'ballots',
            text: 'Ballots',
            handler: 'onBallots'
        }, {
            xtype: 'button',
            itemId: 'save',
            text: 'Save',
            ui: 'action',
            handler: 'onSave'
        }]
    }]
});
