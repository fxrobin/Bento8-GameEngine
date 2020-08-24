package fr.bento8.to8.compiledSprite.patterns;

public class ByteCharSequence implements CharSequence {

    private final byte[] data;
    private final int length;
    private final int offset;

    public ByteCharSequence(byte[] data) {
        this(data, 0, data.length);
    }

    public ByteCharSequence(byte[] data, int offset, int length) {
        this.data = data;
        this.offset = offset;
        this.length = length;
    }

    @Override
    public int length() {
        return this.length;
    }

    @Override
    public char charAt(int index) {
        return (char) (data[offset + index] & 0xff);
    }

    @Override
    public CharSequence subSequence(int start, int end) {
        return new ByteCharSequence(data, offset + start, end - start);
    }

}

//public void testExpression() {
//	byte[] data = new byte[] { 'a', '\r', '\r', 'c' };
//	Pattern p = Pattern.compile("\r\n?|\n\r?");
//	Matcher m = p.matcher(new ByteCharSequence(data));
//
//	assertEquals(true, m.find(0));
//	assertEquals(1, m.start());
//	assertEquals(2, m.end());
//
//	assertEquals(true, m.find(2));
//	assertEquals(2, m.start());
//	assertEquals(3, m.end());
//
//	assertEquals(false, m.find(3));
//}