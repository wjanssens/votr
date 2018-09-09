Ext.define('Votr.view.admin.Ballot', {
    extend: 'Ext.Panel',
    alias: 'widget.admin.ballot',
    layout: 'vbox',
    items: [
        {
            xtype: 'formpanel',
            items: [{
                xtype: 'panel',
                layout: 'hbox',
                padding: 0,
                items: [{
                    xtype: 'textfield',
                    name: 'title',
                    label: 'Title *',
                    flex: 1,
                    bind: {
                        value: '{title}',
                        placeHolder: '{ballotList.selection.title.default}'
                    }
                }, {
                    xtype: 'selectfield',
                    label: 'Language',
                    width: 128,
                    store: 'Languages',
                    bind: {
                        value: '{lang}'
                    }
                }]
            }, {
                xtype: 'panel',
                layout: 'hbox',
                padding: 0,
                items: [{
                    xtype: 'textfield',
                    name: 'description',
                    label: 'Description *',
                    flex: 1,
                    bind: {
                        value: '{description}',
                        placeHolder: '{ballotList.selection.description.default}'
                    }
                }, {
                    xtype: 'selectfield',
                    label: 'Language',
                    width: 128,
                    store: 'Languages',
                    bind: {
                        value: '{lang}'
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
                    {value: 'SSTV', text: 'Scottish STV'},
                    {value: 'MSTV', text: 'Meek STV'},
                    {value: 'FPTP', text: 'Plurality'},
                    {value: 'AV', text: 'Approval'}
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
                name: 'shuffle',
                label: 'Shuffle Candidates',
                value: 'shuffle',
                checked: false,
                tooltip: 'Candidates are shown in a random order',
                bind: '{ballotList.selection.shuffle}'
            }, {
                xtype: 'checkboxfield',
                name: 'mutable',
                label: 'Mutable',
                value: 'mutable',
                checked: false,
                tooltip: 'Voters can change their vote',
                bind: '{ballotList.selection.mutable}'
            }]
        }
    ]
});