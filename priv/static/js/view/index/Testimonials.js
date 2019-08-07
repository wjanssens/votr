Ext.define('Votr.view.index.Testimonials', {
    extend: 'Ext.carousel.Carousel',
    alias: 'widget.index.testimonials',
    layout: 'fit',
    direction: 'vertical',
    style: 'background-color: #455a64; color: white;',
    height: 64,
    defaults: {
        padding: 8
    },
    items: [
        {
            layout: 'hbox',
            defaults: {
                flex: 1
            },
            items: [
                {
                    html: 'Testimonial'
                },
                {
                    html: 'Testimonial'
                },
                {
                    html: 'Testimonial'
                }
            ]
        },
        {
            layout: 'hbox',
            defaults: {
                flex: 1
            },
            items: [
                {
                    html: 'Testimonial'
                },
                {
                    html: 'Testimonial'
                },
                {
                    html: 'Testimonial'
                }
            ]
        },
        {
            layout: 'hbox',
            defaults: {
                flex: 1
            },
            items: [
                {
                    html: 'Testimonial'
                },
                {
                    html: 'Testimonial'
                },
                {
                    html: 'Testimonial'
                }
            ]
        }
    ]
});
