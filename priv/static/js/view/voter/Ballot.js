Ext.define('Votr.view.voter.Ballot', {
    extend: 'Ext.panel.Panel',
    alias: 'widget.voter.ballot',
    layout: 'vbox',
    width: 512,
    border: 1,
    padding: '8px',
    margin: '16px 0',
    title: 'Title',
    setData: function(data) {
        this.callParent(arguments);
        this.setTitle(data.title);
        this.down('#desc').setHtml(data.description);
        this.down('#messages').setHtml(this.getMessages());

        var c = this.down('#candidates');
        data.candidates.forEach(candidate => {
            candidate.ranked = data.ranked;
            candidate.rank = 0;
            candidate.max = data.candidates.length;
            c.add(new Votr.view.voter.Candidate({ data: candidate }));
        });
    },
    getBlt: function() {
        // returns a string representation of the candidate ranking
        // https://www.opavote.com/help/overview#blt-file-format
        var candidates = getData().candidates
            .filter(v => { return v.rank > 0; })
            .reduce((acc, v) => {
                acc[v.rank - 1] = acc[v.rank - 1].concat([v.index]);
                return acc;
            }, new Array(3).fill([]))
            .map(a => { return a.length == 0 ? '-' : a.join('='); })
            .join(' ');
        return `1 ${candidates} 0`;
    },
    getMessages: function() {
        return '';
    },
    items: [
        {
            xtype: 'panel',
            itemId: 'header',
            padding: 0,
            layout: 'vbox',
            items: [
                {
                    xtype: 'component',
                    itemId: 'desc',
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
                }
            ]
        },
        {
            xtype: 'panel',
            itemId: 'candidates',
            padding: 0,
            layout: 'vbox',
            items: [

            ]
        }
    ]
});