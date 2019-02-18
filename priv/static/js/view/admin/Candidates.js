Ext.define('Votr.view.admin.Candidates', {
    extend: 'Ext.Panel',
    alias: 'widget.admin.candidates',
    layout: 'hbox',
    padding: 0,
    referenceHolder: true,
    viewModel: {
        data: {
            lang: 'default'
        },
        stores: {
            candidates: {
                model: 'Votr.model.admin.Candidate',
                proxy: {
                    type: 'rest',
                    url: '../api/admin/ballots/{id}/candidates',
                    reader: { type: 'json', rootProperty: 'candidates' }
                }
            },
            colors: 'Colors',
            languages: 'Languages'
        },
        formulas: {
            language: {
                get: function (get) {
                    return get('lang');
                },
                set: function (selection) {
                    this.set('lang', selection.id)
                }
            },
            color: {
                get: function (get) {
                    return get('candidateList.selection.color');
                },
                set: function (selection) {
                    this.set('candidateList.selection.color', selection.id)
                }
            },
            name: {
                get: function (get) {
                    const names = get('candidateList.selection.names');
                    return names == null ? '' : names[get('language')];
                },
                set: function (value) {
                    const names = Object.assign({}, this.get('candidateList.selection.names'));
                    names[this.get('language')] = value;
                    this.set('candidateList.selection.names', names);
                }
            },
            description: {
                get: function (get) {
                    const descriptions = get('candidateList.selection.descriptions');
                    return descriptions == null ? '' : descriptions[get('language')];
                },
                set: function (value) {
                    const descriptions = Object.assign({}, this.get('candidateList.selection.descriptions'));
                    descriptions[this.get('language')] = value;
                    this.set('candidateList.selection.descriptions', descriptions);
                }
            }
        }
    },
    requires: [
        "Votr.view.admin.CandidatesController"
    ],
    controller: 'admin.candidates',
    items: [{
        xtype: 'list',
        reference: 'candidateList',
        width: 384,
        itemTpl: '<div><div style="float: left; width: 8px; height: 48px; background-color: {color};">&nbsp;</div><img style="float: left; margin-right: 8px;" src="../images/guy.png"/><p>{names.default}<span style="float:right">{percentage * 100}%</span></p><p style="color: var(--highlight-color)">{descriptions.default}</p></div>',
        bind: '{candidates}'
    }, {
        xtype: 'admin.candidate',
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
                disabled: '{!candidateList.selection}'
            }
        }, '->', {
            xtype: 'button',
            text: 'Save',
            ui: 'confirm',
            handler: 'onSave',
            bind: {
                disabled: '{!candidateList.selection}'
            }
        }]
    }]
});
