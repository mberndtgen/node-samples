var chai = require('chai');
var expect = chai.expect;
var Post = require('./../../app/models/post');

describe('Post', function() {
    it('title should not be empty.', function () {
        var post = new Post('not empty');
        expect(post.title).to.equal('not empty');
    });
});