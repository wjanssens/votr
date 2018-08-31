Ext.define('Votr.view.voter.Candidate', {
    extend: 'Ext.panel.Panel',
    alias: 'widget.voter.candidate',
    layout: 'hbox',
    data: {value: 0},
    padding: '8px',
    constructor: function () {
        this.callParent(arguments);
        var data = this.getData();
        this.down('#controls').setData({rank: data.rank, max: data.max, ranked: data.ranked});
        this.down('#name').setHtml(data.name);
        this.down("#desc").setHtml(data.description);
    },
    items: [
        {
            xtype: 'image',
            itemId: 'avatar',
            width: 48,
            height: 48,
            border: 1,
            padding: 0,
            margin: 0,
            src: 'images/guy.png'
        }, {
            xtype: 'panel',
            flex: 1,
            padding: '0 16px',
            layout: 'vbox',
            items: [{
                xtype: 'component',
                padding: '0 0 8px 0',
                itemId: 'name',
                style: 'font-size: 1.5em;',
            }, {
                xtype: 'component',
                itemId: 'desc'
            }]
        }, {
            xtype: 'voter.rankfield',
            itemId: 'controls',
            padding: 0,
        }
    ]
});