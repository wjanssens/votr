Ext.define('Votr.view.voter.Ballots', {
    extend: 'Ext.panel.Panel',
    alias: 'widget.voter.ballots',
    data: {
        ballots: [
            {
                id: '1ab2c3',
                title: 'Title',
                description: 'Description',
                method: 'SSTV',
                ranked: true,
                anonymous: true,
                mutable: false,
                shuffled: true,
                expected: {
                    full: false,
                    strict: false,
                    min: 1,
                    max: 4,
                },
                instructions: [
                    'Votes are counted using the Scottish STV method (Droop quota)',
                    'Rank at least one candidate (with no duplicates)',
                    'You may only vote once (you cannot change your vote)',
                    'Your vote is anonymous',
                    'Candidates are presented in a random order'
                ],
                candidates: [
                    { index: 4, withdrawn: false, name: 'Guy F.', description: 'Conservative Party', id: '1234a1234a' },
                    { index: 2, withdrawn: false, name: 'Guy F.', description: 'Democratic Party', id: '1234a1234a' },
                    { index: 3, withdrawn: false, name: 'Guy F.', description: 'Liberal Party', id: '1234a1234a' },
                    { index: 1, withdrawn: true, name: 'Guy F.', description: 'Green Party', id: '1234a1234a' }
                ]
            },
            {
                id: '4d5e6f',
                title: 'Title',
                description: 'Description',
                method: 'FPTP',
                ranked: false,
                full: false,
                duplicates: false,
                min: 1,
                max: 1,
                anonymous: true,
                mutable: false,
                shuffled: true,
                instructions: [
                    'Votes are counted using the Plurality (FPTP) method',
                    'Select one candidate',
                    'You may only vote once (you cannot change your vote)',
                    'Your vote is anonymous',
                    'Candidates are presented in a random order'
                ],
                candidates: [
                    { index: 2, withdrawn: false, name: 'Guy F.', description: 'Republican', id: '1234a1234a' },
                    { index: 3, withdrawn: false, name: 'Guy F.', description: 'Democrat', id: '1234a1234a' },
                    { index: 1, withdrawn: true, name: 'Guy F.', description: 'Independent', id: '1234a1234a' }
                ]
            }
        ]
    },
    getBlt: function() {
        var result = new Object();
        this.down("#ballots").getItems().forEach(c => {
            result[c.getData().id] = c.getData().blt;
        });
        return result;
    },
    setData: function(data) {
        this.callParent(arguments);
        var c = this.down("#ballots");
        data.ballots.forEach(ballot => {
            c.add(new Votr.view.voter.Ballot({ data: ballot }));
        });
    },
    padding: 0,
    layout: 'vbox',
    items: [
        {
            xtype: 'selectfield',
            label: 'Choose one',
            options: [{
                text: 'English',
                value: 'en'
            }, {
                text: 'French',
                value: 'fr'
            }, {
                text: 'Third Option',
                value: 'third'
            }]
        },
        {
            xtype: 'panel',
            padding: 0,
            itemId: 'ballots',
        },
        {
            xtype: 'button',
            text: 'Vote',
            height: 32,
            ui: 'action',
            itemId: 'voteButton',
        }
    ]
});