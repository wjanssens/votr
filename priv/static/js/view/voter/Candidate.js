Ext.define('Votr.view.voter.Candidate', {
    extend: 'Ext.panel.Panel',
    alias: 'widget.voter.candidate',
    layout: 'hbox',
    padding: '8px',
    constructor() {
        this.callParent(arguments);
        this.down('#controls').addListener('rank', function(newValue, oldValue) {
            this.getData().rank = newValue;
            this.fireEvent('rank', newValue, oldValue);
        }, this);
    },
    setData: function(data) {
        this.callParent(arguments);
        this.down('#controls').setData({rank: data.rank, max: data.max, ranked: data.ranked, withdrawn: data.withdrawn});
        if (data.withdrawn) {
            this.down('#name').setHtml('<p style="background-color: var(--highlight-color); color: white;">' + data.name + '</p>');
            this.down('#desc').setHtml('<p style="background-color: var(--highlight-color); color: white;">' + (data.description || '') + '</p>');
        } else {
            this.down('#name').setHtml(data.name);
            this.down("#desc").setHtml(data.description || '');
        }
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
            src: '../images/guy.png'
        }, {
            xtype: 'panel',
            flex: 1,
            padding: '0 16px',
            layout: 'vbox',
            items: [{
                xtype: 'component',
                padding: '0 0 8px 0',
                itemId: 'name',
                style: 'font-size: 1.5em;'
            }, {
                xtype: 'component',
                itemId: 'desc'
            }]
        }, {
            xtype: 'voter.rankfield',
            itemId: 'controls',
            padding: 0
        }
    ]
});