Ext.define('Votr.view.voter.Ballots', {
    extend: 'Ext.panel.Panel',
    alias: 'widget.voter.ballots',
    layout: 'hbox',
    scrollable: true,
    data: {
        instructions: 'Instructions',
        ballots: [
            {
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
                    'Candidates are presented in a random order.'
                ],
                candidates: [
                    { index: 4, withdrawn: false, name: 'Guy F.', description: 'Conservative Party', id: '1234a1234a' },
                    { index: 2, withdrawn: false, name: 'Guy F.', description: 'Moderate Party', id: '1234a1234a' },
                    { index: 3, withdrawn: false, name: 'Guy F.', description: 'Liberal Party', id: '1234a1234a' },
                    { index: 1, withdrawn: true, name: 'Guy F.', description: 'Wildcard Party', id: '1234a1234a' }
                ]
            }
        ]
    },
    setData: function() {
    },
    items: [
        {
            xtype: 'panel',
            flex: 1
        },
        {
            xtype: 'panel',
            padding: 0,
            items: [
                {
                    xtype: 'panel',
                    padding: '16px auto',
                    html: 'Instructions'
                },
                {
                    xtype: 'voter.ballot'
                }, {
                    xtype: 'voter.ballot'
                }, {
                    xtype: 'voter.ballot'
                }, {
                    xtype: 'voter.ballot'
                }
            ]
        },
        {
            xtype: 'panel',
            flex: 1
        }
    ]
});