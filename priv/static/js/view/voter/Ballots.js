Ext.define('Votr.view.voter.Ballots', {
    extend: 'Ext.panel.Panel',
    alias: 'widget.voter.ballots',
    data: {
        ballots: [
            {
                id: '1ab2c3',
                title: 'STV',
                description: 'This is a sample STV ranked ballot',
                method: 'stv',
                electing: 3,
                anonymous: true,
                mutable: false,
                shuffled: true,
                candidates: [
                    { index: 4, withdrawn: false, name: 'Guy F.', description: 'Conservative Party', id: '1234a1234a' },
                    { index: 2, withdrawn: false, name: 'Guy F.', description: 'Democratic Party', id: '1234a1234a' },
                    { index: 3, withdrawn: false, name: 'Guy F.', description: 'Liberal Party', id: '1234a1234a' },
                    { index: 1, withdrawn: true, name: 'Guy F.', description: 'Green Party', id: '1234a1234a' }
                ]
            },
            {
                id: '4d5e6f',
                title: 'Plurality',
                description: 'This is a sample plurality ballot',
                method: 'plurality',
                electing: 1,
                anonymous: true,
                mutable: false,
                shuffled: true,
                candidates: [
                    { index: 2, withdrawn: false, name: 'Guy F.', description: 'Republican', id: '1234a1234a' },
                    { index: 3, withdrawn: false, name: 'Guy F.', description: 'Democrat', id: '1234a1234a' },
                    { index: 1, withdrawn: true, name: 'Guy F.', description: 'Independent', id: '1234a1234a' }
                ]
            },{
                id: '4d5e6f',
                title: 'Approval',
                description: 'This is a sample approval ballot',
                method: 'approval',
                electing: 1,
                anonymous: true,
                mutable: false,
                shuffled: true,
                candidates: [
                    { index: 2, withdrawn: false, name: 'Sushi', id: '1234a1234a' },
                    { index: 3, withdrawn: false, name: 'Pizza', id: '1234a1234a' },
                    { index: 1, withdrawn: true, name: 'Burgers', id: '1234a1234a' },
                    { index: 5, withdrawn: false, name: 'Chinese', id: '1234a1234a' },
                    { index: 4, withdrawn: false, name: 'Italian', id: '1234a1234a' }
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
    layout: 'vbox',
    padding: 0,
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
            margin: '16 0',
            ui: 'action',
            itemId: 'voteButton',
        }
    ]
});