Ext.define('Votr.view.voter.Ballots', {
    extend: 'Ext.panel.Panel',
    alias: 'widget.voter.ballots',
    layout: 'hbox',
    scrollable: true,
    data: {
        ballots: [
            {
                id: '1ab2c3',
                title: 'Title',
                description: 'Description',
                method: 'SSTV',
                ranked: true,
                full: false,
                duplicates: true,
                anonymous: true,
                mutable: false,
                shuffled: true,
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
    items: [
        {
            xtype: 'panel',
            flex: 1
        },
        {
            xtype: 'panel',
            padding: 0,
            layout: 'vbox',
            items: [
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
        },
        {
            xtype: 'panel',
            flex: 1
        }
    ]
});