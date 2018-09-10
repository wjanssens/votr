Ext.define('Votr.view.voter.Ballot', {
    extend: 'Ext.panel.Panel',
    alias: 'widget.voter.ballot',
    layout: 'vbox',
    border: 1,
    padding: 0,
    margin: '16px 0',
    title: 'Title',
    setData: function(data) {
        this.callParent(arguments);
        this.setTitle(data.title);
        this.down('#description').setHtml(data.description);
        this.down('#instructions').setHtml(data.instructions
            .map(i => `<p>${i}</p>`)
            .join(''));
        this.down('#messages').setHtml(this.getMessages());

        var c = this.down('#candidates');
        data.candidates.forEach(candidate => {
            candidate.ranked = data.ranked;
            candidate.rank = 0;
            candidate.max = data.ranked ? data.candidates.length : 1;
            c.add(new Votr.view.voter.Candidate({
                data: candidate,
                listeners: {
                    scope: this,
                    rank: {
                        fn: function(newValue) {
                            candidate.rank = newValue;
                            this.getData().blt = this.getBlt();
                            console.log(this.getData().blt);
                        }
                    }
                }
            }));
        });
    },
    getBlt: function() {
        // returns a string representation of the candidate ranking
        // https://www.opavote.com/help/overview#blt-file-format
        // no leading weight or trailing 0 included
        var data = this.getData();
        var maxRank = data.candidates
            .reduce((acc, v) => {
                return acc > v.rank ? acc : v.rank;
            }, 0);
        return data.candidates
            .filter(v => { return v.rank > 0; })
            .reduce((acc, v) => {
                acc[v.rank - 1] = acc[v.rank - 1].concat([v.index]);
                return acc;
            }, new Array(maxRank).fill([]))
            .map(a => { return a.length == 0 ? '-' : a.join('='); })
            .join(' ');
    },
    validate: function() {
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
                    itemId: 'description',
                    padding: '8px',
                    html: 'Description'
                },
                {
                    xtype: 'component',
                    itemId: 'instructions',
                    padding: '8px'
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