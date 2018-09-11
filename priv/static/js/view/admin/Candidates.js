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
            candidates: 'Candidates',
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
                    name: '{candidateList.selection.name}',
                    lang: '{lang}'
                },
                get: function(data) {
                    return data.name[data.lang];
                },
                set: function(value) {
                    var lang = this.get('lang');
                    var name = this.get('candidateList.selection.name');
                    name[lang] = value;
                }
            },
            description: {
                bind: {
                    description: '{candidateList.selection.description}',
                    lang: '{lang}'
                },
                get: function(data) {
                    return data.description[data.lang];
                },
                set: function(value) {
                    var lang = this.get('lang');
                    var description = this.get('candidateList.selection.description');
                    description[lang] = value;
                }
            }
        }
    },
    items: [{
        xtype: 'list',
        reference: 'candidateList',
        width: 384,
        itemTpl: '<div><p>{name.default}<span style="float:right">{percentage * 100}%</span></p><p style="color: var(--highlight-color)">{description.default}</p></div>',
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
            text: 'Add Candidate',
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
