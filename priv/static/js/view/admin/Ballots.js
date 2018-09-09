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
            ballots: 'Ballots',
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
                bind: {
                    title: '{ballotList.selection.title}',
                    lang: '{lang}'
                },
                get: function(data) {
                    return data.title[data.lang];
                },
                set: function(value) {
                    var lang = this.get('lang');
                    var title = this.get('ballotList.selection.title');
                    title[lang] = value;
                }
            },
            description: {
                bind: {
                    description: '{ballotList.selection.description}',
                    lang: '{lang}'
                },
                get: function(data) {
                    return data.description[data.lang];
                },
                set: function(value) {
                    var lang = this.get('lang');
                    var description = this.get('ballotList.selection.description');
                    description[lang] = value;
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
        itemTpl: '<div><p>{title.default}<span style="float:right">{electing} / {candidates}</span></p><p style="color: var(--highlight-color)">{description.default}</p></div>',
        bind: '{ballots}'
    }, {
        xtype: 'admin.ballot',
        flex: 1
    }, {
        xtype: 'toolbar',
        itemId: 'toolbar',
        docked: 'bottom',
        items: [{
            xtype: 'button',
            itemId: 'add',
            text: 'Add Ballot',
            handler: 'onAdd'
        }, {
            xtype: 'button',
            enableToggle: true,
            itemId: 'filter',
            iconCls: 'x-fa fa-filter',
            tooltip: 'Show All Ballots',
            handler: 'onFilter'
        }, '->', {
            xtype: 'button',
            itemId: 'candidates',
            text: 'Candidates',
            handler: 'onCandidates'
        }, {
            xtype: 'button',
            itemId: 'results',
            text: 'Results',
            handler: 'onResults'
        }, {
            xtype: 'button',
            itemId: 'log',
            text: 'Log',
            handler: 'onLog'
        }, {
            xtype: 'button',
            itemId: 'save',
            text: 'Save',
            ui: 'action',
            handler: 'onSave'
        }]
    }]
});