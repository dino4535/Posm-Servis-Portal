import '../../styles/Footer.css';

const Footer = () => {
  return (
    <footer className="app-footer">
      <div className="footer-content">
        <p className="footer-text">
          <span className="powered-by">Powered By</span>{' '}
          <span className="developer-name">Oğuz EMÜL</span>
          <span className="footer-separator"> | </span>
          <span className="footer-description">
            © {new Date().getFullYear()} Oğuz EMÜL. Tüm hakları saklıdır.
          </span>
        </p>
      </div>
    </footer>
  );
};

export default Footer;
