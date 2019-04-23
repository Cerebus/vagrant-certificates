module VagrantPlugins
  module Certificates
    module Cap
      module Windows
        # Capability for configuring the certificate bundle on CoreOS.
        module UpdateCertificateBundle
          def self.update_certificate_bundle(m)
            # Import the certificates into the local machine root store
            m.communicate.sudo("Get-ChildItem -Path C:/ssl/certs | Foreach-Object {certutil -addstore -enterprise -f 'Root' $_.FullName}")
            # Also import the certificates into a bundle to be referenced by SSL_CERT_FILE
            m.communicate.sudo("Remove-Item -Path C:/ssl/cacert.pem; Get-ChildItem -Path C:/ssl/certs | Get-Content | Out-File -FilePath C:/ssl/cacert.pem -Encoding utf8 -Append")
            # Convert the cacerts.pem with Windows line endings ('\r\n') to Unix line endings ('\n')
            m.communicate.sudo("$cacertContents = [io.file]::ReadAllText('C:/ssl/cacert.pem') -replace \"`r`n\",\"`n\"; [io.file]::WriteAllText('C:/ssl/cacert_unix.pem', $cacertContents)")
          end
        end
      end
    end
  end
end
