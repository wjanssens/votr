Ext.define('Votr.view.voter.Ballot', {
    extend: 'Ext.panel.Panel',
    alias: 'widget.voter.ballot',
    layout: 'vbox',
    width: 512,
    border: 1,
    padding: '8px',
    margin: '16px 0',
    title: 'Title',
    items: [
        {
            xtype: 'component',
            itemId: 'description',
            padding: '8px',
            html: 'Description'
        },
        {
            xtype: 'component',
            itemId: 'instructions',
            padding: '8px',
            html: '<ul>' +
            '<li>Votes are counted using the Scottish STV method (Droop quota)</li>' +
            '<li>Rank at least one candidate (with no duplicates)</li>' +
            '<li>You may only vote once (you cannot change your vote)</li>' +
            '<li>Your vote is anonymous</li>' +
            '<li>Candidates are presented in a random order</li>' +
            '</ul>'
        },
        {
            xtype: 'component',
            itemId: 'messages',
            padding: '8px',
            html: 'Error / Warning Messages'
        },
        {
            xtype: 'voter.candidate',
            data: { name: 'Name 1', description: 'Conservative Party', rank: 3, max: 99, ranked: true }
        }, {
            xtype: 'voter.candidate',
            data: { name: 'Name 2', description: 'Moderate Party', rank: 0, max: 99, ranked: true }
        }, {
            xtype: 'voter.candidate',
            data: { name: 'Name 3', description: 'Liberal Party', rank: 1, max: 1, ranked: false }
        }, {
            xtype: 'voter.candidate',
            data: { name: 'Name 4', description: 'Wildcard Party', rank: 0, max: 1, ranked: false }
        }
    ]
});