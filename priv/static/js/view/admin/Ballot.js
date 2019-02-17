Ext.define('Votr.view.admin.Ballot', {
    extend: 'Ext.form.Panel',
    alias: 'widget.admin.ballot',
    layout: 'vbox',
    bind: {
        disabled: '{!ballotList.selection}'
    },
    items: [
        {
            xtype: 'container',
            layout: 'hbox',
            padding: 0,
            items: [{
                xtype: 'textfield',
                name: 'title',
                label: 'Title *',
                flex: 1,
                bind: {
                    value: '{title}',
                    placeHolder: '{ballotList.selection.titles.default}'
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
            xtype: 'container',
            layout: 'hbox',
            padding: 0,
            items: [{
                xtype: 'textfield',
                name: 'description',
                label: 'Description *',
                flex: 1,
                bind: {
                    value: '{description}',
                    placeHolder: '{ballotList.selection.descriptions.default}'
                }
            }, {
                xtype: 'selectfield',
                label: 'Language',
                width: 128,
                store: 'Languages',
                bind: {
                    store: '{languages}',
                    value: '{language}'
                }
            }]
        }, {
            xtype: 'textfield',
            name: 'ext_id',
            label: 'External ID',
            bind: '{ballotList.selection.ext_id}'
        }, {
            xtype: 'selectfield',
            label: 'Method *',
            name: 'method',
            options: [
                {value: 'scottish_stv', text: 'Scottish STV'},
                {value: 'meek_stv', text: 'Meek STV'},
                {value: 'plurality', text: 'Plurality'},
                {value: 'approval', text: 'Approval'}
            ],
            bind: '{method}'
        }, {
            xtype: 'selectfield',
            label: 'Quota *',
            queryMode: 'local',
            name: 'quota',
            options: [
                {value: 'droop', text: 'Droop [ (v / (s + 1)) + 1 ]'},
                {value: 'hare', text: 'Hare [ v / s ]'},
                {value: 'imperator', text: 'Imperator [ v / (s + 2) ]'},
                {value: 'hagenback-bischoff', text: 'Hagenbach Bischoff [ v / (s + 1) ]'},
            ],
            bind: '{quota}'
        }, {
            xtype: 'spinnerfield',
            label: 'Electing',
            minValue: 1,
            value: 1,
            stepValue: 1,
            name: 'electing',
            tooltip: 'How many candidates are being elected',
            bind: '{ballotList.selection.electing}'
        }, {
            xtype: 'checkboxfield',
            name: 'anonymous',
            label: 'Anonymous',
            value: 'anonymous',
            checked: false,
            tooltip: 'Results are anonymous',
            bind: '{ballotList.selection.anonymous}'
        }, {
            xtype: 'checkboxfield',
            name: 'shuffle',
            label: 'Shuffle Candidates',
            value: 'shuffle',
            checked: false,
            tooltip: 'Candidates are shown in a random order',
            bind: '{ballotList.selection.shuffled}'
        }, {
            xtype: 'checkboxfield',
            name: 'mutable',
            label: 'Mutable',
            value: 'mutable',
            checked: false,
            tooltip: 'Voters can change their vote',
            bind: '{ballotList.selection.mutable}'
        }, {
            xtype: 'checkboxfield',
            name: 'public',
            label: 'Public Results',
            value: 'public',
            checked: false,
            tooltip: 'Election results are public',
            bind: '{ballotList.selection.public}'
        }, {
            xtype: 'panel',
            layout: 'hbox',
            items: [
                {flex: 1},
                {
                    xtype: 'button', ui: 'alt round', margin: 8, height: 96, width: 96, handler: 'onCandidates', bind: {
                        html: '<span style="line-height: 1em; font-size: 24px;">{ballotList.selection.candidate_ct}</span><br/>Candidates'
                    }
                },
                {flex: 1}
            ]
        }
    ]
});