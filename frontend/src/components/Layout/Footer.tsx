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
            © {new Date().getFullYear()} Oğuz EMÜL. Bu sistemin tüm fikri hakları, tasarım ve yazılım geliştirme hakları Oğuz EMÜL'e aittir.
          </span>
        </p>
      </div>
    </footer>
  );
};

export default Footer;
