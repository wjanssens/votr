Ext.define('Votr.view.admin.Ballots', {
    extend: 'Ext.Panel',
    alias: 'widget.admin.ballots',
    layout: 'hbox',
    padding: 0,
    referenceHolder: true,
    viewModel: {
        data: {
            lang: 'default'
        },
        stores: {
            ballots: {
                model: 'Votr.model.admin.Ballot',
                proxy: {
                    type: 'rest',
                    url: '../api/admin/wards/{id}/ballots',
                    reader: { type: 'json', rootProperty: 'ballots' }
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
            method: {
                bind: {
                    method: '{ballotList.selection.method}'
                },
                get: function(data) {
                    return data.method;
                },
                set: function(selection) {
                    console.log(selection);
                    this.set('ballotList.selection.method', selection.data.value)
                }
            },
            quota: {
                bind: {
                    quota: '{ballotList.selection.quota}'
                },
                get: function(data) {
                    return data.quota;
                },
                set: function(selection) {
                    this.set('ballotList.selection.quota', selection.data.value)
                }
            },
            title: {
                get: function (get) {
                    const titles = get('ballotList.selection.titles');
                    return titles == null ? '' : titles[get('language')];
                },
                set: function (value) {
                    const titles = Object.assign({}, this.get('ballotList.selection.titles'));
                    titles[this.get('language')] = value;
                    this.set('ballotList.selection.titles', titles);
                }
            },
            description: {
                get: function (get) {
                    const descriptions = get('ballotList.selection.descriptions');
                    return descriptions == null ? '' : descriptions[get('language')];
                },
                set: function (value) {
                    const descriptions = Object.assign({}, this.get('ballotList.selection.descriptions'));
                    descriptions[this.get('language')] = value;
                    this.set('ballotList.selection.descriptions', descriptions);
                }
            }
        }
    },
    requires: [
        "Votr.view.admin.BallotsController"
    ],
    controller: 'admin.ballots',
    items: [{
        xtype: 'list',
        reference: 'ballotList',
        width: 384,
        itemTpl: '<div><p>{titles.default}<span style="float:right">{electing} / {candidate_ct}</span></p><p style="color: var(--highlight-color)">{description.default}</p></div>',
        bind: {
            store: '{ballots}'
        }
    }, {
        xtype: 'admin.ballot',
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
                disabled: '{!ballotList.selection}'
            }
        }, '->', {
            xtype: 'button',
            text: 'Save',
            ui: 'confirm',
            handler: 'onSave',
            bind: {
                disabled: '{!ballotList.selection}'
            }
        }]
    }]
});