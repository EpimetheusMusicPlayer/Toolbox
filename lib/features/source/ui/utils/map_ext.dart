String mapExt(String ext) =>
    const {
      'scss': 'jsx',
      'gif': 'jsx',
      'png': 'jsx',
      'jpg': 'jsx',
      'svg': 'jsx',
      'swf': 'jsx',
    }[ext] ??
    ext;
