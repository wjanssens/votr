Ext.define('Votr.view.admin.Ballot', {
    extend: 'Ext.Panel',
    alias: 'widget.admin.ballot',
    layout: 'vbox',
    items: [
        {
            xtype: 'formpanel',
            items: [{
                xtype: 'textfield',
                name: 'title',
                label: 'Title *'
            }, {
                xtype: 'textfield',
                name: 'desc',
                label: 'Description'
            }, {
                xtype: 'textfield',
                name: 'ext_id',
                label: 'External ID'
            }, {
                xtype: 'selectfield',
                label: 'Method *',
                queryMode: 'local',
                name: 'method',
                options: [
                    {value: 'STVD', text: 'STV (Droop)'},
                    {value: 'STVH', text: 'STV (Hare)'},
                    {value: 'STVI', text: 'STV (Imperator)'},
                    {value: 'STVB', text: 'STV (Hagenbach Bischoff)'},
                    {value: 'IRV', text: 'Instant Runoff'},
                    {value: 'FPTP', text: 'Plurality'},
                    {value: 'AV', text: 'Approval'}
                ]
            }, {
                xtype: 'spinnerfield',
                label: 'Electing',
                minValue: 1,
                value: 1,
                stepValue: 1,
                name: 'elect',
                tooltip: 'How many candidates are being selected'
            }, {
                xtype: 'checkboxfield',
                name: 'shuffle',
                label: 'Shuffle',
                value: 'shuffle',
                checked: false,
                tooltip: 'Candidates are shown in a random order'
            }, {
                xtype: 'checkboxfield',
                name: 'mutable',
                label: 'Mutable',
                value: 'mutable',
                checked: false,
                tooltip: 'Voters can change their vote'
            }]
        }, {
            xtype: 'polar',
            reference: 'chart',
            width: '100%',
            height: 256,
            insetPadding: 20,
            innerPadding: 20,
            background: 'transparent',
            store: {
                fields: ['os', 'data1' ],
                data: [
                    { candidate: 'Candidate 1', votes: 68.3 },
                    { candidate: 'Candidate 3', votes: 17.9 },
                    { candidate: 'Candidate 4', votes: 10.2 },
                    { candidate: 'Candidate 5', votes: 1.9 },
                    { candidate: 'Candidate 2', votes: 1.7 },
                    { candidate: 'Exhausted', votes: 1.9 }
                ]
            },
            interactions: ['rotate'],
            series: [{
                type: 'pie',
                angleField: 'votes',
                label: {
                    field: 'candidate'
                },
                highlight: true
            }]
        }
    ]
});